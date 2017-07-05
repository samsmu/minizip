
#-----------------------------------------------------------------------------
# ExternalProjects
#-----------------------------------------------------------------------------

set(external_projects
  ZLIB
  )

#-----------------------------------------------------------------------------
# External project settings
#-----------------------------------------------------------------------------

include(ExternalProject)

set(ep_prefix "${CMAKE_BINARY_DIR}/ep")
set_property(DIRECTORY PROPERTY EP_PREFIX ${ep_prefix})

# It makes these directories for downloaded dependencies (GMP, MPFR)
file(MAKE_DIRECTORY ${ep_prefix}/bin)
file(MAKE_DIRECTORY ${ep_prefix}/lib)
file(MAKE_DIRECTORY ${ep_prefix}/include)

set(ep_install_dir ${ep_prefix})
set(ep_suffix "-cmake")
set(ep_build_shared_libs ON)
set(ep_build_testing OFF)

# Compute -G arg for configuring external projects with the same CMake generator:
if(CMAKE_EXTRA_GENERATOR)
  set(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
  set(gen "${CMAKE_GENERATOR}")
endif()

# Use this value where semi-colons are needed in ep_add args:
set(sep "^^")

##  Explicit setting of Windows version

if(WIN32)
  # for the best compatibility, always set Windows version to XP
  set(ver "0x501")

  # this method adds the necessary compiler flag
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_WIN32_WINNT=${ver}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_WIN32_WINNT=${ver}")
  # this adds a preprocessor definition to the project
  add_definitions(-D_WIN32_WINNT=${ver})
endif()

##  Explicit setting of Unix version

if(CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

##

set(ep_common_C_FLAGS "${CMAKE_C_FLAGS}")
set(ep_common_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

if(MSVC_VERSION)
  set(ep_common_C_FLAGS "${ep_common_C_FLAGS} /bigobj /MP")
  set(ep_common_CXX_FLAGS "${ep_common_CXX_FLAGS} /bigobj /MP")
endif()

set(ep_common_args
  -DBUILD_TESTING:BOOL=${ep_build_testing}
  -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
  -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_FLAGS:STRING=${ep_common_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${ep_common_CXX_FLAGS}
  -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
  -DCMAKE_CXX_EXTENSIONS:STRING=${CMAKE_CXX_EXTENSIONS}
  -DCMAKE_CXX_STANDARD_REQUIRED:STRING=${CMAKE_CXX_STANDARD_REQUIRED}

  -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
  -DCMAKE_SHARED_LINKER_FLAGS_RELEASE:STRING=${CMAKE_SHARED_LINKER_FLAGS_RELEASE}
  -DCMAKE_EXE_LINKER_FLAGS_RELEASE:STRING=${CMAKE_EXE_LINKER_FLAGS_RELEASE}
  -DCMAKE_MODULE_LINKER_FLAGS_RELEASE:STRING=${CMAKE_MODULE_LINKER_FLAGS_RELEASE}
)

# Include external projects
foreach(p ${external_projects})
  include(CMakeExternals/${p}.cmake)
endforeach()
