const fs = require('fs');
const path = require('path');

const SCORES_DIR = path.resolve(__dirname, '../data/scores_repo');
const DATA_DIR = path.resolve(__dirname, '../data');

// Clean helper
function cleanText(str) {
  if (!str) return '';
  return str.toString().trim();
}

function normalizeName(str) {
  return cleanText(str)
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, '')
    .replace(/\s+/g, ' ');
}

function tokenize(str) {
  return normalizeName(str).split(' ').filter(Boolean);
}

function nameMatches(nameA, nameB) {
  const nA = normalizeName(nameA);
  const nB = normalizeName(nameB);
  if (nA === nB) return true;
  const tA = tokenize(nameA);
  const tB = tokenize(nameB);
  if (tA.length === tB.length && tA.every(t => tB.includes(t))) return true;
  // If at least 2 tokens match
  const matches = tA.filter(t => tB.includes(t));
  if (matches.length >= 2) return true;
  return false;
}

function calculateGradeAndRemark(totalOut20) {
  // Scale of 20 for mid-term tests (2 tests of 10 max each)
  const pct = (totalOut20 / 20) * 100;
  if (pct >= 85) return { grade: 'A1', remark: 'Excellent Distinction', color: '#16a34a' };
  if (pct >= 75) return { grade: 'B2', remark: 'Very Good', color: '#2563eb' };
  if (pct >= 65) return { grade: 'B3', remark: 'Good', color: '#0284c7' };
  if (pct >= 55) return { grade: 'C4', remark: 'Credit', color: '#4f46e5' };
  if (pct >= 50) return { grade: 'C5', remark: 'Satisfactory', color: '#6366f1' };
  if (pct >= 45) return { grade: 'C6', remark: 'Fair', color: '#d97706' };
  if (pct >= 40) return { grade: 'P7', remark: 'Pass', color: '#f59e0b' };
  return { grade: 'F9', remark: 'Needs Improvement', color: '#dc2626' };
}

function getEstimatedAge(grade, dateOfBirth) {
  if (dateOfBirth) {
    const y = new Date(dateOfBirth).getFullYear();
    if (!isNaN(y) && y > 1990 && y < 2026) {
      return 2026 - y;
    }
  }
  const g = (grade || '').toLowerCase();
  if (g.includes('creche') || g.includes('play')) return 3;
  if (g.includes('kg 1')) return 4;
  if (g.includes('kg 2')) return 5;
  if (g.includes('primary 1') || g.includes('pry 1')) return 6;
  if (g.includes('primary 2') || g.includes('pry 2')) return 7;
  if (g.includes('primary 3') || g.includes('pry 3')) return 8;
  if (g.includes('primary 4') || g.includes('pry 4')) return 9;
  if (g.includes('primary 5') || g.includes('pry 5')) return 10;
  if (g.includes('primary 6') || g.includes('pry 6')) return 11;
  if (g.includes('jss 1')) return 12;
  if (g.includes('jss 2')) return 13;
  if (g.includes('jss 3')) return 14;
  if (g.includes('sss 1') || g.includes('ss 1')) return 15;
  if (g.includes('sss 2') || g.includes('ss 2')) return 16;
  if (g.includes('sss 3') || g.includes('ss 3')) return 17;
  return 13;
}

// 1. Load migration
const migPath = path.join(SCORES_DIR, 'Stanbax_Complete_Migration_88_Scholars_Logins_Subjects_2026-10-29 2.json');
const migData = JSON.parse(fs.readFileSync(migPath, 'utf8'));

// Build student map: regNumber/id -> student
const studentsMap = new Map();

for (const s of migData.students) {
  const regNumber = cleanText(s.regNumber);
  const student = {
    ...s,
    regNumber,
    name: cleanText(s.name),
    grade: cleanText(s.grade) || 'JSS 1',
    gender: cleanText(s.gender) || (s.name.includes('Esther') || s.name.includes('Amina') || s.name.includes('Favour') || s.name.includes('Vivian') || s.name.includes('Zainab') || s.name.includes('Mary') || s.name.includes('Ruth') || s.name.includes('Elizabeth') || s.name.includes('Blessing') || s.name.includes('Kafilat') || s.name.includes('Tamara') ? 'Female' : 'Male'),
    age: s.age || getEstimatedAge(s.grade, s.dateOfBirth),
    password: 'stanbax2025', // All students have same password as required
    aliases: Array.isArray(s.aliases) ? [...s.aliases] : [],
    midtermScores2026: {},
    grades: Array.isArray(s.grades) ? [...s.grades] : []
  };

  // Add name permutations to aliases for flexible logins
  const tokens = tokenize(student.name);
  if (tokens.length >= 2) {
    // Surname + Firstname
    student.aliases.push(student.name);
    student.aliases.push(`${tokens[tokens.length - 1]} ${tokens[0]}`);
    student.aliases.push(`${tokens[0]} ${tokens[tokens.length - 1]}`);
  }

  studentsMap.set(regNumber || s.id, student);
}

// Helper to find student by reg, or name
function findStudent(reg, name) {
  if (reg && studentsMap.has(reg)) {
    return studentsMap.get(reg);
  }
  if (name) {
    for (const s of studentsMap.values()) {
      if (nameMatches(s.name, name)) {
        return s;
      }
      for (const al of s.aliases) {
        if (nameMatches(al, name)) {
          return s;
        }
      }
    }
  }
  return null;
}

// 2. Process CSV Score Files
function processCsv(filename, defaultGrade) {
  const filePath = path.join(SCORES_DIR, filename);
  if (!fs.existsSync(filePath)) return;
  const content = fs.readFileSync(filePath, 'utf8').trim();
  const lines = content.split('\n').filter(l => l.trim().length > 0);
  if (lines.length < 2) return;

  const headers = lines[0].split(',').map(h => cleanText(h));
  // Subjects appear in pairs: "Math (1st Test)", "Math (2nd Test)"
  // Extract subjects
  const subjectMap = [];
  for (let i = 3; i < headers.length; i++) {
    const h = headers[i];
    if (h.includes('(1st Test)')) {
      const sub = h.replace(' (1st Test)', '').trim();
      const test2Idx = headers.findIndex(x => x === `${sub} (2nd Test)`);
      subjectMap.push({ subject: sub, ca1Idx: i, ca2Idx: test2Idx });
    }
  }

  for (let r = 1; r < lines.length; r++) {
    const parts = lines[r].split(',').map(p => cleanText(p));
    const reg = parts[0];
    const name = parts[1];
    const gradeLevel = parts[2] || defaultGrade;

    let student = findStudent(reg, name);
    if (!student) {
      // Create student if missing
      const id = `std-csv-${Date.now()}-${r}`;
      student = {
        id,
        regNumber: reg || `SBS/2026/${id}`,
        name: name,
        grade: gradeLevel || defaultGrade,
        gender: 'Male',
        age: getEstimatedAge(gradeLevel || defaultGrade, null),
        password: 'stanbax2025',
        aliases: [name],
        midtermScores2026: {},
        grades: []
      };
      studentsMap.set(student.regNumber, student);
    }

    // Prioritize migration name if student already exists, but record CSV name as alias
    if (name && !student.aliases.includes(name)) {
      student.aliases.push(name);
    }

    // Attach scores
    for (const sInfo of subjectMap) {
      const val1 = parseFloat(parts[sInfo.ca1Idx]);
      const val2 = sInfo.ca2Idx >= 0 ? parseFloat(parts[sInfo.ca2Idx]) : NaN;
      if (!isNaN(val1) || !isNaN(val2)) {
        const ca1 = isNaN(val1) ? 0 : val1;
        const ca2 = isNaN(val2) ? 0 : val2;
        student.midtermScores2026[sInfo.subject] = { ca1, ca2 };
      }
    }
  }
}

processCsv('Jss1.csv', 'JSS 1');
processCsv('Kg1.csv', 'KG 1');
processCsv('Kg2.csv', 'KG 2');
processCsv('Pry1.csv', 'Primary 1');
processCsv('Ss2_science.csv', 'SSS 2 Science');
processCsv('Ss2art.csv', 'SSS 2 Arts & Commercial');

// 3. Process JSON Score Files
function processJsonFile(filename, defaultGrade) {
  const filePath = path.join(SCORES_DIR, filename);
  if (!fs.existsSync(filePath)) return;
  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const targetGrade = data.class || defaultGrade;

  for (const s of data.students || []) {
    const rawName = cleanText(s.name);
    let student = findStudent(s.registration_no || s.regNo, rawName);

    // Special name aliases from prompt instructions
    if (!student) {
      if (rawName.toLowerCase().includes('odubanjo michael') || rawName.toLowerCase().includes('odubanjo micheal')) {
        student = findStudent(null, 'Odubanjo Micheal');
      } else if (rawName.toLowerCase().includes('abayomi tamara')) {
        student = findStudent(null, 'Tamara Abayomi');
      } else if (rawName.toLowerCase().includes('daramola darasimi')) {
        student = findStudent(null, 'Daralis Daramola');
      } else if (rawName.toLowerCase().includes('onygho divine') || rawName.toLowerCase().includes('onyigho divine')) {
        student = findStudent(null, 'Ondigho Divine');
      } else if (rawName.toLowerCase().includes('alao esther')) {
        student = findStudent(null, 'Ajao Esther');
      } else if (rawName.toLowerCase().includes('alibawo jamiloju')) {
        student = findStudent(null, 'Ajibowo Jomiloju Ruth');
      } else if (rawName.toLowerCase().includes('azeez halliah')) {
        student = findStudent(null, 'Azeez Haliyah');
      } else if (rawName.toLowerCase().includes('oliver afomachukwu')) {
        student = findStudent(null, 'Oliva Afomachukwu');
      } else if (rawName.toLowerCase().includes('onyigho vigor')) {
        student = findStudent(null, 'Oniigho Vigor');
      } else if (rawName.toLowerCase().includes('oladiipo darasimi')) {
        student = findStudent(null, 'Oladipo Darasimi');
      }
    }

    if (!student) {
      // If student is truly new (not in DB)
      const id = `std-json-${Date.now()}-${Math.floor(Math.random()*1000)}`;
      student = {
        id,
        regNumber: s.registration_no || `SBS/2026/${id}`,
        name: rawName,
        grade: s.class || targetGrade,
        gender: 'Male',
        age: getEstimatedAge(s.class || targetGrade, null),
        password: 'stanbax2025',
        aliases: [rawName],
        midtermScores2026: {},
        grades: []
      };
      studentsMap.set(student.regNumber, student);
    }

    if (rawName && !student.aliases.includes(rawName)) {
      student.aliases.push(rawName);
    }

    // Attach scores: ONLY CHOOSE FIRST TWO TESTS if 3 exist (e.g. 10, 5, 8 -> 10, 5)
    for (const [sub, sc] of Object.entries(s.scores || {})) {
      let ca1 = 0;
      let ca2 = 0;
      if (typeof sc === 'object' && sc !== null) {
        ca1 = parseFloat(sc['1st_test']) || 0;
        ca2 = parseFloat(sc['2nd_test']) || 0;
        // sc['3rd_test'] is intentionally omitted per user instructions
      } else if (typeof sc === 'number') {
        ca1 = sc;
      }
      student.midtermScores2026[sub] = { ca1, ca2 };
    }
  }
}

processJsonFile('Pry.json', 'Primary 2');
processJsonFile('jss2_scores.json', 'JSS 2');
processJsonFile('ss1_scores.json', 'SSS 1 Science');

// 4. Process SS3: "ss3 are 4 science students (all male) and 2 arts (females)"
const ss3Path = path.join(SCORES_DIR, 'ss3_scores.json');
if (fs.existsSync(ss3Path)) {
  const ss3Data = JSON.parse(fs.readFileSync(ss3Path, 'utf8'));
  let ss3Index = 1;
  for (const s of ss3Data.students || []) {
    const rawName = cleanText(s.name);
    let student = findStudent(null, rawName);
    
    // Explicit classification per user: 4 science (all male), 2 arts (females)
    const isArtsFemale = rawName.toLowerCase().includes('uchechukwu') || rawName.toLowerCase().includes('favour');
    const grade = isArtsFemale ? 'SSS 3 Arts & Commercial' : 'SSS 3 Science';
    const gender = isArtsFemale ? 'Female' : 'Male';

    if (!student) {
      const reg = `SBS/2026/SS3/${String(ss3Index).padStart(3, '0')}`;
      const id = `std-ss3-${ss3Index}`;
      student = {
        id,
        regNumber: reg,
        name: rawName,
        grade,
        gender,
        age: 17,
        password: 'stanbax2025',
        email: `sbs2026ss3${String(ss3Index).padStart(3, '0')}@stanbaxschools.edu.ng`,
        aliases: [rawName],
        midtermScores2026: {},
        grades: [],
        attendancePercent: 100,
        attendanceDays: 60,
        totalSchoolDays: 60,
        feeStatus: 'Fully Paid',
        house: ss3Index % 4 === 1 ? 'Sapphire (Blue House)' : ss3Index % 4 === 2 ? 'Ruby (Red House)' : ss3Index % 4 === 3 ? 'Emerald (Green House)' : 'Topaz (Yellow House)'
      };
      studentsMap.set(reg, student);
      ss3Index++;
    } else {
      student.grade = grade;
      student.gender = gender;
      student.age = 17;
    }

    for (const [sub, sc] of Object.entries(s.scores || {})) {
      let ca1 = 0;
      let ca2 = 0;
      if (typeof sc === 'object' && sc !== null) {
        ca1 = parseFloat(sc['1st_test']) || 0;
        ca2 = parseFloat(sc['2nd_test']) || 0;
      }
      student.midtermScores2026[sub] = { ca1, ca2 };
    }
  }
}

// 5. Finalize Grades Array and Midterm Records for Each Student
const finalizedStudents = Array.from(studentsMap.values()).map(student => {
  // If student has midterm scores, build the formal grades list
  const midtermEntries = Object.entries(student.midtermScores2026 || {});
  if (midtermEntries.length > 0) {
    const midtermGrades = midtermEntries.map(([subject, scores], idx) => {
      const ca1 = scores.ca1 || 0;
      const ca2 = scores.ca2 || 0;
      const total = ca1 + ca2;
      const { grade, remark, color } = calculateGradeAndRemark(total);
      return {
        id: `grd-${student.id}-${idx + 1}`,
        subject,
        ca1,
        ca2,
        ca3: 0,
        exam: 0,
        total,
        grade,
        remark,
        color,
        term: '1st Term',
        academicSession: '2026/2027 Academic Session',
        isMidterm: true
      };
    });

    student.grades = midtermGrades;
    const totalScore = midtermGrades.reduce((sum, g) => sum + g.total, 0);
    student.termAverage = Math.round((totalScore / midtermGrades.length) * 10) / 10;
  }

  // Enforce specific grade and department classifications per school directive:
  const n = (student.name || '').toLowerCase();
  
  // SS3: 4 Science (all male), 2 Arts (females)
  if (n.includes('uchechukwu') || (n.includes('iteji') && n.includes('favour'))) {
    student.grade = 'SSS 3 Arts & Commercial';
    student.gender = 'Female';
    student.age = 17;
  } else if (n.includes('ademijoke') || n.includes('chidubem') || n.includes('onyedika') || (n.includes('adeleke') && n.includes('joshua'))) {
    student.grade = 'SSS 3 Science';
    student.gender = 'Male';
    student.age = 17;
  }

  // SS2: 2 Science (Bello Mordiyah and Alabi Blessing), 3 Arts (Taofeek Fawas, Oladele Esther, Kafilat Balogun)
  if (n.includes('bello mordiyah') || n.includes('alabi blessing')) {
    student.grade = 'SSS 2 Science';
    student.gender = 'Female';
    student.age = 16;
  } else if (n.includes('kafilat balogun')) {
    student.grade = 'SSS 2 Arts & Commercial';
    student.gender = 'Female';
    student.age = 16;
  } else if (n.includes('taofeek fawas')) {
    student.grade = 'SSS 2 Arts & Commercial';
    student.gender = 'Male';
    student.age = 16;
  } else if (n.includes('oladele esther')) {
    student.grade = 'SSS 2 Arts & Commercial';
    student.gender = 'Female';
    student.age = 16;
  }

  // SS1: 4 Science (Ezenwa Vivian, Yekinni Omotoyosi, Adeniyi Moses, Odubanjo Irewamiri), 3 Arts (Oladipo Darasimi, Asimiyu Abdulsalam, Yekinni Zainab)
  if (n.includes('ezenwa vivian') || n.includes('yekinni omotoyosi') || n.includes('adeniyi moses') || n.includes('odubanjo irewamiri')) {
    student.grade = 'SSS 1 Science';
    if (n.includes('adeniyi moses')) student.gender = 'Male';
    else student.gender = 'Female';
    student.age = 15;
  } else if (n.includes('oladipo darasimi') || n.includes('asimiyu abdulsalam') || n.includes('yekinni zainab')) {
    student.grade = 'SSS 1 Arts & Commercial';
    if (n.includes('asimiyu')) student.gender = 'Male';
    else student.gender = 'Female';
    student.age = 15;
  }

  // Ensure age and gender exist for the portal profile
  if (!student.age) {
    student.age = getEstimatedAge(student.grade, student.dateOfBirth);
  }
  if (!student.gender) {
    student.gender = 'Male';
  }

  return student;
});

// Write to data/students.json
fs.writeFileSync(path.join(DATA_DIR, 'students.json'), JSON.stringify(finalizedStudents, null, 2), 'utf8');

console.log(`Successfully integrated ${finalizedStudents.length} students into data/students.json!`);
const withMidterm = finalizedStudents.filter(s => Object.keys(s.midtermScores2026 || {}).length > 0);
console.log(`Students with 2026 First Term Midterm scores attached: ${withMidterm.length}`);
console.log(`SS3 accounts count: ${finalizedStudents.filter(s => s.grade === 'SSS 3').length}`);
