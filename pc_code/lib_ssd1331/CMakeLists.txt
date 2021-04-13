cmake_minimum_required(VERSION 3.5)
project(ssd1331 LANGUAGES C VERSION 0.0.1)

add_library(ssd1331 STATIC src/ftdi_util.c src/ssd_displ.c src/ssd_displ_graph.c)
target_include_directories(ssd1331 PUBLIC include)

set(C_RELEASE_OPTIONS -Wall -Werror=format-security -Werror=implicit-function-declaration -Werror=return-type)
set(C_DEBUG_OPTIONS ${C_RELEASE_OPTIONS})
target_compile_options(ssd1331 PRIVATE "$<$<CONFIG:DEBUG>:${C_DEBUG_OPTIONS}>")
target_compile_options(ssd1331 PRIVATE "$<$<CONFIG:RELEASE>:${C_RELEASE_OPTIONS}>")

find_library(FTDI_LIB ftdi1)
target_link_libraries(ssd1331 INTERFACE ${FTDI_LIB})

include(GNUInstallDirs)
install(TARGETS ssd1331
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
