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
