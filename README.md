[![DOI](https://img.shields.io/badge/DOI-10.82901%2Fnemar.nm000409-blue)](https://doi.org/10.82901/nemar.nm000409)

# ECoG during a simple auditory reaction-time task (derivative)

Electrocorticography (ECoG) from 8 subjects performing a simple reaction-time task (press a button as fast as possible
after an auditory stimulus), released with the code of:

> Cho H, Schalk G, Adamek M, Moheimanian L, Coon WG, Jun SC, Wolpaw JR, Brunner P (2021). Revealing the physiological
> origin of event-related potentials using electrocorticography in humans. bioRxiv, https://doi.org/10.1101/2021.02.12.430921

Source record: Zenodo https://doi.org/10.5281/zenodo.4361654 (CC-BY-4.0), `Evoked_Potentials_ECoG_Data.zip`
("ECoG activity from eight human subjects; EEG activity from seven human subjects; recorded during a simple
reaction-time task").

**This is a derivative dataset**: the release holds the authors' downsampled (400 Hz) epochs, not continuous recordings.

## Files

For each subject `sub-01` ... `sub-08` (release files `s1` ... `s8`), three BrainVision files (float32 = the release's
float64 values rounded), epochs written back to back, trial `k` at the same position in all three:

- `desc-stimlocked`: -1.0 to +1.5 s around the auditory stimulus (1000 samples per trial);
- `desc-responselocked`: -1.5 to +1.5 s around the button press (1200 samples per trial);
- `desc-rest`: a 1-s rest segment per trial (400 samples), used by the authors as baseline.

Epoch windows are those of the authors' figure scripts (`linspace(-1,1.5,srate*2.5)`, `linspace(-1.5,1.5,srate*3)`).
`*_events.tsv` has one row per trial at the alignment point. `channels.tsv` marks the channels the paper used as
auditory (`ach_data_final.mat`) and motor (`mch_data_final.mat`) channels.

## Limitations

- The release has no channel names (channels are numbered `ch001...` in column order), no electrode positions matched to
  the channels, and no per-subject age or sex.
- The physical unit is not stated; the channels are labelled µV as an assumption.
- The original sampling rate and the anti-alias filter used for downsampling are not stated.
- Line frequency 60 Hz is taken from the release's notch parameters (58-62 Hz, 117-123 Hz).
- `sourcedata/zenodo-4361654/sub-XX_parameters.json` holds the analysis parameters stored in each subject file, without
  the original file paths, subject numbers and brain-model file names (these carry site study codes).
- The EEG data, figure data, cortical models and code of the release are not copied; they remain in the source record.

## Licence

CC-BY-4.0, as the source record. Please cite the preprint and the Zenodo record.

## Additional metadata and localisation (added 2026-10-08)

Compiled after the upload from the article, its supplement and the source deposit (each statement names its source). Text and sidecar metadata only; no data file was changed.

**Recording system.** BCI2000 with eight 16-channel g.USBamp amplifiers or one 256-channel g.HIamp (g.tec), sampling rate 1,200 Hz; a connector split the cables between the clinical system and the research amplifiers (doi:10.1101/2021.02.12.430921, Methods 'Data collection'). The deposited s<N>_auditory_ds.mat are downsampled ('_ds'): the preprint downsampled 1200 -> 400 Hz after 0.05 Hz high-pass and common median reference (doi:10.1101/2021.02.12.430921, 'Data pre-processing'); each file holds ecog.rest_data, ecog.stim_data, ecog.button_data (samples x channels), ecog.srate, ecog.n_trials, ecog.parameters (Voyager Job ieeg-b3enr-c-cho-erp-1007221214).

**Reference scheme.** Offline common median reference, excluding channels with excessive 60 Hz noise (doi:10.1101/2021.02.12.430921). Hardware reference not stated (n/a).

**Electrode types.** Subdural grids (Ad-Tech Medical, Racine WI; PMT, Chanhassen MN), platinum-iridium, 4 mm diameter (2.3 mm exposed), 10 mm centre-to-centre (doi:10.1101/2021.02.12.430921, Methods 'Subjects').

**Localisation method.** Postoperative radiographs and CT, with MRI, were used to build subject-specific 3D cortical models and derive electrode locations (Coon et al. 2016) (doi:10.1101/2021.02.12.430921). The deposit contains, per subject, the brain model with electrode coordinates (data/s<N>_brain.mat and talairach_alignment/s<N>/orig_brain_model.mat) and the same electrodes aligned to the activeBrain Talairach template (talairach_alignment/s<N>/talairach_tal_brain_model.mat); These positions are not assigned to channels in this dataset: the release has no channel names and each subject's data have 0-5 more columns than the brain model has electrodes (see coordsystem.json), so the electrode-to-channel mapping cannot be verified.

## Correction (2026-10-09)

The `hemisphere` column of `participants.tsv` listed all eight subjects as left. It had been copied from the release analysis parameter `IsRightHemisphere`, which is `no` in every subject file. The preprint (doi:10.1101/2021.02.12.430921, Methods 'Subjects') places the grids in the left hemisphere for S1, S3, S6 and S7 and in the right hemisphere for S2, S4, S5 and S8, and the electrode coordinates in the deposit agree (positive x for s2, s4, s5 and s8). `sub-02`, `sub-04`, `sub-05` and `sub-08` are now `right`. No data file or coordinate was changed.
