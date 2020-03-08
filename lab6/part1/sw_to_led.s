    mvi r4, 0
    mvi r5, 0
    mvhi r4, 0x20
    mvhi r5, 0x30

LOOP:
    ld r0, r4
    st r0, r5
    j LOOP