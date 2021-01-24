# Include the functions used in this file
include(SolversListFunctions)

######## Define link libraries and runtime files ########
# The variable ${name_LIBRARY} should contain the first
# The variable ${name_DIST} should contain the latter
if(WIN32)
  AddLibs(cplex LIBVERSION 2010 
                LINKLIBS "cplex2010.lib"
                DIST "cplex2010.dll")

  AddLibs(gurobi LIBVERSION 911
                LINKLIBS "gurobi91.lib"
                DIST "gurobi91.dll")
  
  AddLibs(path LIBVERSION 47
                LINKLIBS "path47.lib"
                DIST "path47.dll")

  AddLibs(snopt LINKLIBS "snopt.lib")

  AddLibs(xpress LIBVERSION 37.01.01
                LINKLIBS "xprs.lib"
                DIST "xprl.dll" "xprs.dll")


elseif(APPLE) 
  AddLibs(cplex LIBVERSION 2010 
                LINKLIBS "libcplex2010.dylib"
                DIST "libcplex2010.dylib")

  AddLibs(gurobi LIBVERSION 911
                LINKLIBS "libgurobi91.dylib"
                DIST "libgurobi91.dylib")
  
  AddLibs(path LINKLIBS "libpath47.dylib"
                DIST "libpath47.dylib")
  
  AddLibs(snopt LINKLIBS "libsnopt_clang.a")

  AddLibs(xpress LIBVERSION 37.01.01
                LINKLIBS "libxprs.dylib"
                DIST "libxprl.dylib" "libxprs.dylib")

  else() # LINUX 
  AddLibs(cplex LIBVERSION 2010 
                LINKLIBS "libcplex2010.so"
                DIST "libcplex2010.so")

  AddLibs(gurobi LIBVERSION 911
                LINKLIBS "libgurobi91.so"
                DIST "libgurobi91.so")
  
  AddLibs(path LINKLIBS "libpath47.dylib"
                DIST "libpath47.dylib")
  
  AddLibs(snopt LINKLIBS "libsnopt64.a")

  AddLibs(xpress LIBVERSION 37.01.01
                LINKLIBS "libxprs.so.37.01"
                DIST "libxprs.so.37.01" "libxprl.so.x8.11")
endif()


# Cplex
defineSolver(cplex 20210105
SRCDIR ${BASE_DRIVER_SRC_DIR}/cplex
SOURCES cplex.c
INCLUDE ${cplex_INCLUDE_DIR}
LIBS ${cplex_LIBS} 
DIST ${cplex_DIST}
ASL asl2-dynrt)


# Gurobi
defineSolver(gurobi 20201230
SRCDIR ${BASE_DRIVER_SRC_DIR}/gurobi
SOURCES gurobi.c
INCLUDE ${gurobi_INCLUDE_DIR}
LIBS ${gurobi_LIBS}
DIST ${gurobi_DIST}
ASL asl)


### Loqo
if(APPLE)
  set(LOQODEF GNU)
endif()
defineSolver(loqo 20201030
SRCDIR ${BASE_DRIVER_SRC_DIR}/loqo
SOURCES aloqo.c
ASL asl2
BUILDLIB libloqo
DEFS ${LOQODEF}
)



# Minos 
if(NOT WIN32)
  set(MINOSLIB "m")
else()
  set(MINOSLIB "")
endif()
defineSolver(minos 20201030
SRCDIR ${BASE_DRIVER_SRC_DIR}/minos
SOURCES m551
ASL asl2
LIBS  f2c
BUILDLIB minos551_lib ${MINOSLIB}
)

# Snopt 
defineSolver(snopt 20201030
EXTERNALBUILD
SRCDIR ${BASE_DRIVER_SRC_DIR}/snopt
SOURCES snopt.c
ASL asl2
LIBS ${snopt_LIBS} f2c
)

# Xpress
defineSolver(xpress 20201230
SRCDIR ${BASE_DRIVER_SRC_DIR}/xpress
SOURCES xpress.c
ASL asl2
INCLUDE ${xpress_INCLUDE_DIR}
LIBS ${xpress_LIBS}
DIST ${xpress_DIST}
)