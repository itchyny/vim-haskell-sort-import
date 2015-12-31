import CA
#if __GLASGOW_HASKELL__ >= 706
import BA
#else
import AA
#endif

#if __GLASGOW_HASKELL__ >= 706
import CB
import AB
import BB
#else
import CC
import AC
import BC
#endif
