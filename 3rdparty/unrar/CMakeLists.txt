CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6 FATAL_ERROR)
PROJECT(unrar CXX)
INCLUDE(ExternalProject)

ExternalProject_Add(project_unrar
  URL
    ${CMAKE_CURRENT_SOURCE_DIR}/unrarsrc
  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
  PATCH_COMMAND
    ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/unrar_project.cmake CMakeLists.txt
  INSTALL_DIR
    ${CMAKE_CURRENT_BINARY_DIR}/install/
  STEP_TARGETS
    configure
)

# Force rebuild of unrar lib if any of these dependencies change
ExternalProject_Add_Step(project_unrar rebuild
  DEPENDERS
    download
  DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/unrar_project.cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/unrarsrc
    ${CMAKE_CURRENT_LIST_FILE}
)

IF(TOP_BINARY_DIR)
  set(include_directories ${CMAKE_CURRENT_BINARY_DIR}/install/include/)
  file(WRITE ${TOP_BINARY_DIR}/exports/unrar.cmake
"
add_library(unrar STATIC IMPORTED)
# TODO: Add library from libarchive that unrar depends on to implement the file.cpp and file.hpp
#add_dependencies(unrar project_unrar libarchive_XY_LIBRARY) 
set_property(TARGET unrar APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(unrar PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG \"CXX\"
  IMPORTED_LINK_INTERFACE_LIBRARIES_NOCONFIG \"${link_libraries}\"
  IMPORTED_LOCATION_NOCONFIG \"${CMAKE_CURRENT_BINARY_DIR}/install/${CMAKE_STATIC_LIBRARY_PREFIX}unrar${CMAKE_STATIC_LIBRARY_SUFFIX}\"
  INCLUDE_DIRECTORIES \"${include_directories}\"
  )
set(unrar_INCLUDE_DIR ${include_directories})
"
)
ENDIF(TOP_BINARY_DIR)


