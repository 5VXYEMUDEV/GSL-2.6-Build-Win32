if(APPLE)
  set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "MacOS minimum version")
endif()

cmake_minimum_required(VERSION 3.3)
project(asl-solvers)

set(CMAKE_CXX_STANDARD 98)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set the path to CMake modules.
set(AMPL_CMAKE_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/support/cmake ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${AMPL_CMAKE_MODULE_DIR})
message("CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}")
# Initialize the architecture: must be done first thing, as it initalizes the
# variable ARCH below
include(initArchitecture)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
include(addPrefix) # for add_prefix, add_to_folder and append

# Package version number
set(VERSION_NUMBER 1.0)

# Set output directories.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Set paths
set(BASE_DRIVER_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/solvers)
set(BASE_SOLVER_LIBS ${CMAKE_CURRENT_SOURCE_DIR}/../../solver-libraries)
set(SOLVER_NAMES "")

# Define solver-related functions
# Define all solvers characteristics in a predictable format, specifically, for each
# solver 's1' defines variables:
# s1_DRIVER_SOURCES, s1_DRIVER_VERSION, s1_DRIVER_LIBS, s1_DRIVER_DIST
# s1_DRIVER_ASL, , s1_DRIVER_INCLUDE_DIRS, , s1_DRIVER_COMPILE_OPTIONS,
# s1_DRIVER_PREPROCESSOR_DEFS
# And the global: SOLVER_NAMES (containing the list of all solver defined)
# and NEEDED_ASL containing the names of the asl versions needed
include(SolversList)
# Set compiler settings
setGlobalCompilerSettings()

# Check which solvers we want to build parsing the command line -DBUILD=s1,..,sn string
# Defines the variables ENABLE_solvername to ON or OFF appropriately
parseCommandLine()



# Set which ASL we need to compile
if("${NEEDED_ASL}" MATCHES "dynrt")
  set(BUILD_DYNRT_LIBS ON)
endif()
if("${NEEDED_ASL}" MATCHES "mt")
  set(BUILD_MT_LIBS ON)
endif()
if(ENABLE_lgo AND ${ARCH} EQUAL 64)
  set(BUILD_MCMODELLARGE ON)
endif()

# Add fortran2c libraries if needed
if(ENABLE_minos OR ENABLE_snopt)
  set(GENERATED_INCLUDE_DIR ${CMAKE_BINARY_DIR}/include)
  add_subdirectory(f2c)
endif()

# Build ASL
add_subdirectory(src)
# Add ASL targets to a folder in the IDE
add_to_folder(asl asl asl2 asl2-dynrt asl-dynrt asl-mt asl2-mt asl2-large arith-h)


# Check dependencies and create solver targets
foreach(solver ${SOLVER_NAMES})
  if(${ENABLE_${solver}})
    checksolver(${solver})
    createSolverTarget(${solver})
  endif()
endforeach()
