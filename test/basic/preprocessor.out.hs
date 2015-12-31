import CA
#if __GLASGOW_HASKELL__ >= 706
import BA
#else
import AA
#endif

#if __GLASGOW_HASKELL__ >= 706
import AB
import BB
import CB
#else
import AC
import BC
import CC
#endif
