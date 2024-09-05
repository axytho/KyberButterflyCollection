# KyberButterflyCollection
A collection of butterfly circuits for Kyber-parameter NTTs

The lowest area butterfly is butterfly_Best. Since the butterfly circuit is taken from Yaman et al. (Creative Commons code) (while the modular reduction is my own code), for using any butterfly circuit one must include the Mert butterfly additional logic.

If you're looking at this repository, you're probably interested in utilizing one of these. In the current version a lot of the butterfly circuits have unclear names and I haven't added the testbench code yet, but probably will soon.

You'll probably need to look at the testbench code to see how to actually use any of the butterflies using K-reduction (because their twiddle factors have to be premultiplied with k inverse).

If there are any questions you can always contact me at jonas.bertels@esat.kuleuven.be.
