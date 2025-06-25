import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

# Define BIDS keys
t1w = create_key('sub-{subject}/anat/sub-{subject}_T1w')
bold_move1 = create_key('sub-{subject}/func/sub-{subject}_task-MOVE1_bold')
bold_move2 = create_key('sub-{subject}/func/sub-{subject}_task-MOVE2_bold')
fmap_magnitude = create_key('sub-{subject}/fmap/sub-{subject}_magnitude1')
fmap_phase = create_key('sub-{subject}/fmap/sub-{subject}_phasediff')

def infotodict(seqinfo):
    info = {t1w: [], bold_move1: [], bold_move2: [], fmap_magnitude: [], fmap_phase: []}

    for s in seqinfo:
        # Adjust these match strings based on your actual series descriptions / protocol names
        if 'mpsage' in s.series_description.lower():
            info[t1w].append(s.series_id)
        elif 'MOVE_1' in s.series_description:
            info[bold_move1].append(s.series_id)
        elif 'MOVE_2' in s.series_description:
            info[bold_move2].append(s.series_id)
        elif 'fieldmap' in s.series_description and 'magnitude' in s.series_description:
            info[fmap_magnitude].append(s.series_id)
        elif 'fieldmap' in s.series_description and 'phase' in s.series_description:
            info[fmap_phase].append(s.series_id)

    return info
#
#def infotoids(seqinfo, outdir):
#    """Extract subject ID and session ID from DICOM info"""
#    subj = seqinfo[0].patient_id
#    ses = None  # or extract session info if applicable
#    return subj, ses, None
