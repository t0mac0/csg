if (GIT_EXECUTABLE)
  #later use git describe here
  execute_process( COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
    WORKING_DIRECTORY ${TOP_SOURCE_DIR}
    OUTPUT_VARIABLE THIS_GIT_ID OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process( COMMAND ${GIT_EXECUTABLE} diff-index --name-only HEAD
    WORKING_DIRECTORY ${TOP_SOURCE_DIR}
    OUTPUT_VARIABLE _HAS_CHANGES OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)
  if (NOT "${_HAS_CHANGES}" STREQUAL "")
    set(THIS_GIT_ID "${THIS_GIT_ID} (dirty)")
  endif()
  message("Current git revision is ${THIS_GIT_ID}")
  set(THIS_GIT_ID "gitid: ${THIS_GIT_ID}")
else()
  set (THIS_GIT_ID)
endif()
file(READ ${INPUT} CONTENT)
string(REGEX REPLACE "#CSG_GIT_ID#" "${THIS_GIT_ID}" NEW_CONTENT "${CONTENT}")
file(WRITE "${OUTPUT}.tmp" "${NEW_CONTENT}")
execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OUTPUT}.tmp ${OUTPUT})
execute_process(COMMAND ${CMAKE_COMMAND} -E remove ${OUTPUT}.tmp)
