#[=======================================================================[.rst:
Findsdl2-image
--------------

Find the sdl2-image includes and libraries.

IMPORTED Targets
^^^^^^^^^^^^^^^^

This module defines the `IMPORTED` targets ``SDL2::SDL2_image``, if
sdl2-image has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

	SDL2IMAGE_FOUND         - True if sdl2-image found.
	SDL2IMAGE_INCLUDE_DIRS  - Where to find SDL2/SDL_image.h.
	SDL2IMAGE_LIBRARIES     - Libraries when using sdl2-image.

#]=======================================================================]

# first specifically look for the CMake config version of sdl2-image
find_package(sdl2-image QUIET NO_MODULE)
mark_as_advanced(sdl2-image_FOUND)

include(FindPackageHandleStandardArgs)
if(sdl2-image_FOUND)
	find_package_handle_standard_args(sdl2-image HANDLE_COMPONENTS CONFIG_MODE)
	return()
endif()

# if not using config mode, let's find SDL2
find_package(SDL2 REQUIRED) 

# let's try pkg-config
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(PC_SDL2IMAGE REQUIRED SDL2_image>=${sdl2-image_FIND_VERSION})
endif()

find_package_handle_standard_args(sdl2-image DEFAULT_MSG PC_SDL2IMAGE_LIBRARIES PC_SDL2IMAGE_INCLUDE_DIRS)

if(sdl2-image_FOUND)
	if(NOT TARGET SDL2::SDL2_image)
		# the .pc file for SDL2_image contains `<prefix>/include/SDL2` which is different from the cmake version
		# i.e. `<prefix>/include`
		get_filename_component(SDL2IMAGE_INCLUDE_DIRS ${PC_SDL2IMAGE_INCLUDE_DIRS} DIRECTORY)

		set(SDL2IMAGE_INCLUDE_DIRS ${SDL2IMAGE_INCLUDE_DIRS} CACHE STRING "SDL2 include directories")
		set(SDL2IMAGE_LIBRARIES ${PC_SDL2IMAGE_LIBRARIES} CACHE STRING "SDL2 libraries")
		
		mark_as_advanced(SDL2IMAGE_INCLUDE_DIRS SDL2IMAGE_LIBRARIES)

		add_library(SDL2::SDL2_image INTERFACE IMPORTED)
		set_target_properties(SDL2::SDL2_image PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${SDL2IMAGE_INCLUDE_DIRS}"
			INTERFACE_LINK_DIRECTORIES "${PC_SDL2IMAGE_LIBDIR}"
			INTERFACE_LINK_LIBRARIES "${SDL2IMAGE_LIBRARIES}")
	endif()
endif()
