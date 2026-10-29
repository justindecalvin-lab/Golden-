# Scores Repository Integration & Backup Data Source
**Source Repository:** `https://github.com/justindecalvin/Scores`  
**Host Application:** `Stanbax Schools Ibadan (Kinggg)`  
**Strict Codebase Separation Notice:** This directory contains raw files imported from the secondary repository (`Scores`), preserved in complete isolation from application UI logic and server middleware.

---

## Imported Files Manifest

| File | Content & Purpose | Handling Rules |
| :--- | :--- | :--- |
| `Stanbax_Complete_Migration_88_Scholars_Logins_Subjects_2026-10-29 2.json` | Master backup migration file containing 88 scholars, logins, school info, and initial grade records. | **Prioritize names on this file** over external score spellings (e.g. `Odubanjo Micheal`, `Daralis Daramola`, `Tamara Abayomi`, `Ondigho Divine`). |
| `Jss1.csv` | Mid-term scores for 1st Term 2026 (JSS 1). | 1st Test & 2nd Test scores attached to scholar portals. |
| `Kg1.csv` | Mid-term scores for 1st Term 2026 (KG 1). | 1st Test & 2nd Test scores attached to scholar portals. |
| `Kg2.csv` | Mid-term scores for 1st Term 2026 (KG 2). | 1st Test & 2nd Test scores attached to scholar portals. |
| `Pry1.csv` | Mid-term scores for 1st Term 2026 (Primary 1). | 1st Test & 2nd Test scores attached to scholar portals. |
| `Pry.json` | Mid-term scores for Primary 2 and Primary 3. | 1st Test & 2nd Test scores attached to scholar portals. |
| `jss2_scores.json` | Mid-term scores for 1st Term 2026 (JSS 2). | 1st Test & 2nd Test scores attached to scholar portals. |
| `ss1_scores.json` | Mid-term scores for 1st Term 2026 (SSS 1). | **3-Test Rule Enforced**: When 3 tests exist (e.g. 10, 5, 8 in English Studies), ONLY the first two tests are chosen. |
| `Ss2_science.csv` | Mid-term scores for SSS 2 Science. | 1st Test & 2nd Test scores attached to scholar portals. |
| `Ss2art.csv` | Mid-term scores for SSS 2 Arts & Commercial. | 1st Test & 2nd Test scores attached to scholar portals. |
| `ss3_scores.json` | Mid-term scores for SSS 3. | **New Accounts Created**: 6 scholars (`Ezenwa Uchechukwu`, `Iteji Favour`, `Ademijoke David`, `Ejionye Chidubem`, `Okwuchukwu Onyedika`, `Adeleke Joshua`) assigned Reg Numbers `SBS/2026/SS3/001` through `006`, age 17, and password `stanbax2025`. |

---

## Scholar Portal Display Rules
- **Profile fields shown**: Name, Sex (Gender), Age, and Class (Grade level).
- **Logins**: Permitted via Registration Number (`SBS/2026/JSS1/001`), Surname & Firstname (`Taofeek Fawas` or `Fawas Taofeek`), or All Names (`Oladele Esther Ayomide`).
- **Portal Password**: Universal password `stanbax2025` enabled for all scholars.
