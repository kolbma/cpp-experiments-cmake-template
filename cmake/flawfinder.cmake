
find_program(FLAWFINDER flawfinder)
if(FLAWFINDER)
  message(STATUS "add flawfinder target")
  add_custom_target(flawfinder
    COMMAND
      ${FLAWFINDER}
      --context
      --error-level=1
      --immediate
      --
      apps src include)
else()
  message(WARNING "flawfinder not found")
endif()
