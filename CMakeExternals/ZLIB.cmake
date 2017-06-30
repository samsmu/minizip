#------------------------------------------------------------------
# ZLIB
#------------------------------------------------------------------
  set(proj ZLIB)
  set(proj_DEPENDENCIES )
  set(ZLIB_DEPENDS ${proj})

  find_package(ZLIB)

  if(ZLIB_FOUND)
  else(ZLIB_FOUND)
    set(additional_cmake_args )
    if(CTEST_USE_LAUNCHERS)
      list(APPEND additional_cmake_args
        "-DCMAKE_PROJECT_${proj}_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake"
      )
    endif()

    ExternalProject_Add(${proj}
      LIST_SEPARATOR ${sep}
      GIT_REPOSITORY "https://github.com/madler/zlib.git"
      GIT_TAG "v1.2.11"
      CMAKE_ARGS
        ${ep_common_args}
        ${additional_cmake_args}
      CMAKE_CACHE_ARGS
        ${ep_common_cache_args}
        -DBUILD_SHARED_LIBS:BOOL=OFF
      CMAKE_CACHE_DEFAULT_ARGS
        ${ep_common_cache_default_args}
      DEPENDS ${proj_DEPENDENCIES}
      )
    set(${MY_PROJECT_NAME}_ZLIB_DIR ${ep_prefix})
    set(${MY_PROJECT_NAME}_ZLIB_INCLUDE_DIR ${${MY_PROJECT_NAME}_ZLIB_DIR}/include)
    set(${MY_PROJECT_NAME}_ZLIB_LIBRARY_DIR ${${MY_PROJECT_NAME}_ZLIB_DIR}/lib)
    set(${MY_PROJECT_NAME}_ZLIB_LIBRARY_RELEASE ${${MY_PROJECT_NAME}_ZLIB_LIBRARY_DIR}/zlib.lib)
    set(${MY_PROJECT_NAME}_ZLIB_LIBRARY_DEBUG ${${MY_PROJECT_NAME}_ZLIB_LIBRARY_DIR}/zlibd.lib)

    install(DIRECTORY ${${MY_PROJECT_NAME}_ZLIB_INCLUDE_DIR}
            DESTINATION .
            COMPONENT dev)

    set(lib_path ${${MY_PROJECT_NAME}_ZLIB_DIR})

    find_library(library_release NAMES zlib
                 PATHS ${lib_path}
                 PATH_SUFFIXES lib lib/Release
                 NO_DEFAULT_PATH)
    find_library(library_debug NAMES zlibd
                 PATHS ${lib_path}
                 PATH_SUFFIXES lib lib/Debug
                 NO_DEFAULT_PATH)

    set(library )
    if(library_release)
      list(APPEND library ${library_release})
      install(FILES ${library_release}
              DESTINATION lib
              CONFIGURATIONS Release
              COMPONENT dev)
    endif()
    if(library_debug)
      list(APPEND library ${library_debug})
      install(FILES ${library_debug}
              DESTINATION lib
              CONFIGURATIONS Debug
              COMPONENT dev)
    endif()

    set(${MY_PROJECT_NAME}_LIBRARY ${library})

  endif(ZLIB_FOUND)

