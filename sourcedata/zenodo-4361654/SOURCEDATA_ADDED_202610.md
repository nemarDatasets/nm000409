# Original release files added to sourcedata/ (2026-10)

Added in the sourcedata completion pass of 2026-10: 145 files, 4.83 GB.

- The release's data/ folder (8 subject ECoG files s1-s8_auditory_ds.mat, brain models, Talairach alignment files, analysis results) and the authors' own code (top-level scripts, functions/*.m, README.txt) of Evoked_Potentials_ECoG_Data.zip.
- Left out: functions/eeglab2019_1/ and functions/activeplot/ (bundled copies of public third-party toolboxes) and .DS_Store.

Changes for privacy:

- Struct field ecog.parameters: runs2analyze, BrainModelFile and Subject blanked (24 fields; they held original file paths with site study codes and subject numbers). Those files were rewritten by scipy.io.savemat (MAT v5, compressed); all numeric content verified identical.
- Any other string holding a file path or site/study code (e.g. in the Talairach brain-model files) blanked: 16 strings; those files were rewritten the same way.
- Other MAT files: header 'Created on' day set to 01 (58 files), data bytes unchanged.
- Every string in every added MAT file was checked for site/study codes and file paths: none left.

Before upload every added file passed the campaign privacy gate (file names, text, MAT headers and strings, zip member names and text members: no day-of-month other than 01, no names or identifiers).
