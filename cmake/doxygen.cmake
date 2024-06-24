find_package(Doxygen)

if(DOXYGEN_FOUND)
  set(DOXYGEN_CREATE_SUBDIRS YES)
  set(DOXYGEN_DISABLE_INDEX NO)
  if(Doxygen_dot_FOUND)
    set(DOXYGEN_DOT_IMAGE_FORMAT svg)
    set(DOXYGEN_DOT_TRANSPARENT YES)
  endif()
  set(DOXYGEN_EXTRACT_ALL YES)
  set(DOXYGEN_FULL_SIDEBAR NO)
  set(DOXYGEN_GENERATE_TREEVIEW YES)
  set(DOXYGEN_HTML_EXTRA_STYLESHEET 
    doxygen-awesome-css/doxygen-awesome.css
    doxygen-awesome-css/doxygen-awesome-sidebar-only.css)
  set(DOXYGEN_HTML_FOOTER ${CMAKE_SOURCE_DIR}/doxygen/footer.html)
  set(DOXYGEN_HTML_HEADER  ${CMAKE_SOURCE_DIR}/doxygen/header.html)  
  set(DOXYGEN_HTML_COLORSTYLE LIGHT)
  set(DOXYGEN_HTML_OUTPUT ./)
  set(DOXYGEN_HTML_STYLESHEET ${CMAKE_SOURCE_DIR}/doxygen/stylesheet.css)
  set(DOXYGEN_INTERNAL_DOCS YES)
  set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/docs)
  set(DOXYGEN_SOURCE_BROWSER YES)

  file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/docs/doxygen-awesome-css)
  file(COPY_FILE
    ${CMAKE_SOURCE_DIR}/.cpm_cache/doxygen-awesome-css/161a5dd1a97682b887d351d6246cd486e3d35611/doxygen-awesome-css/doxygen-awesome.css
    ${CMAKE_SOURCE_DIR}/docs/doxygen-awesome-css/doxygen-awesome.css
    ONLY_IF_DIFFERENT)
  file(COPY_FILE
    ${CMAKE_SOURCE_DIR}/.cpm_cache/doxygen-awesome-css/161a5dd1a97682b887d351d6246cd486e3d35611/doxygen-awesome-css/doxygen-awesome-sidebar-only.css
    ${CMAKE_SOURCE_DIR}/docs/doxygen-awesome-css/doxygen-awesome-sidebar-only.css
    ONLY_IF_DIFFERENT)

  doxygen_add_docs(
    docs
    ${CMAKE_SOURCE_DIR}/apps
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/include
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/docs)
  message(STATUS "doxygen: added docs target")
endif()
