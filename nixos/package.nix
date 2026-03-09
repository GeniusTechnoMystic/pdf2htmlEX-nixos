{ lib
, cairo
, cmake
, fetchFromGitHub
, fontconfig
, fontforge
, freetype
, gettext
, ghostscript
, glib
, jre_headless
, libjpeg
, libjpeg_turbo
, libpng
, libxml2
, openjpeg
, pango
, pkg-config
, poppler
, python3
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "pdf2htmlEX";
  version = "v0.18.8.rc1-nixos-25.11";

  # Important: Points to the root of your repo from the /nixos folder
  src = ../.;

  # Tell Nix to enter the C++ source directory before building
  sourceRoot = "${builtins.baseNameOf src}/pdf2htmlEX";

  # Expose the version directly to the CMake environment
  PDF2HTMLEX_VERSION = version;

  nativeBuildInputs = [ 
    cmake 
    pkg-config 
    jre_headless
    python3
  ];

  buildInputs = [
    poppler
    fontforge
    cairo
    freetype
    fontconfig
    libjpeg
    libjpeg_turbo
    openjpeg
    libpng
    libxml2
    glib
    zlib
    gettext
  ];

  # These flags ensure Nix-style installation paths
  cmakeFlags = [
    "-DENABLE_SVG=ON"
  ];

  # The upstream CMakeLists attempts to find Poppler in ../poppler
  # We need to tell it to look in the standard Nix paths instead.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-quiet "cmake_minimum_required(VERSION 2.6.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.5 FATAL_ERROR)" \
      
    # Upstream forgets to ask pkg-config for GLib and LibXML2 include paths. 
    # We forcefully inject this into CMake so it maps the Nix store paths to the C compiler.
    sed -i '/find_package(PkgConfig)/a pkg_check_modules(NIX_DEPS REQUIRED glib-2.0 gio-2.0 gobject-2.0 libxml-2.0)\ninclude_directories(''${NIX_DEPS_INCLUDE_DIRS})' CMakeLists.txt

  '';

  # Compile the headless, static FontForge using upstream's exact flags
  preConfigure = ''
    echo "Unlocking parent directory permissions..."
    chmod u+w ..

    # ==========================================
    #  BUILD INTERNAL STATIC POPPLER
    # ==========================================
    echo "Injecting pristine Poppler source..."
    mkdir -p ../poppler
    if [ -d "${poppler.src}" ]; then
      cp -a ${poppler.src}/* ../poppler/
    else
      tar xf ${poppler.src} -C ../poppler --strip-components=1
    fi
    chmod -R u+w ../poppler

    echo "Building internal static Poppler..."
    pushd ../poppler
    mkdir build && cd build
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=OFF \
      -DENABLE_UNSTABLE_API_ABI_HEADERS=OFF \
      -DBUILD_GTK_TESTS=OFF \
      -DBUILD_QT5_TESTS=OFF \
      -DBUILD_QT6_TESTS=OFF \
      -DBUILD_CPP_TESTS=OFF \
      -DBUILD_MANUAL_TESTS=OFF \
      -DENABLE_BOOST=OFF \
      -DENABLE_SPLASH=ON \
      -DENABLE_UTILS=OFF \
      -DENABLE_CPP=OFF \
      -DENABLE_GLIB=ON \
      -DENABLE_GOBJECT_INTROSPECTION=OFF \
      -DENABLE_GTK_DOC=OFF \
      -DENABLE_QT5=OFF \
      -DENABLE_QT6=OFF \
      -DENABLE_LIBOPENJPEG="openjpeg2" \
      -DENABLE_DCTDECODER="libjpeg" \
      -DENABLE_CMS="none" \
      -DENABLE_LCMS=OFF \
      -DENABLE_LIBCURL=OFF \
      -DENABLE_LIBTIFF=OFF \
      -DWITH_TIFF=OFF \
      -DWITH_NSS3=OFF \
      -DENABLE_NSS3=OFF \
      -DENABLE_GPGME=OFF \
      -DENABLE_ZLIB=ON \
      -DENABLE_ZLIB_UNCOMPRESS=OFF \
      -DUSE_FLOAT=OFF \
      -DRUN_GPERF_IF_PRESENT=OFF \
      -DEXTRA_WARN=OFF \
      -DWITH_JPEG=ON \
      -DWITH_PNG=ON \
      -DWITH_Cairo=ON
    make -j$NIX_BUILD_CORES
    popd

    # ==========================================
    #  BUILD INTERNAL STATIC FONTFORGE
    # ==========================================
    echo "Injecting pristine FontForge source..."
    mkdir -p ../fontforge
    if [ -d "${fontforge.src}" ]; then
      cp -a ${fontforge.src}/* ../fontforge/
    else
      tar xf ${fontforge.src} -C ../fontforge --strip-components=1
    fi
    chmod -R u+w ../fontforge

    echo "Building internal static FontForge..."
    pushd ../fontforge

    mkdir build && cd build
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=OFF \
      -DENABLE_GUI=OFF \
      -DENABLE_X11=OFF \
      -DENABLE_NATIVE_SCRIPTING=ON \
      -DENABLE_PYTHON_SCRIPTING=OFF \
      -DENABLE_PYTHON_EXTENSION=OFF \
      -DENABLE_LIBSPIRO=OFF \
      -DENABLE_LIBUNINAMESLIST=OFF \
      -DENABLE_LIBGIF=OFF \
      -DENABLE_LIBJPEG=ON \
      -DENABLE_LIBPNG=ON \
      -DENABLE_LIBREADLINE=OFF \
      -DENABLE_LIBTIFF=OFF \
      -DENABLE_WOFF2=OFF \
      -DENABLE_DOCS=OFF
      
    make -j$NIX_BUILD_CORES
    popd
  '';

  meta = with lib; {
    description = "PDF to HTML converter - NixOS optimized fork";
    homepage = "https://github.com/GeniusTechnoMystic/pdf2htmlEX-nixos";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "pdf2htmlEX";
  };
}
