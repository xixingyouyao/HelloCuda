#-------------------------------------------------
#
# Project created by QtCreator 2014-03-17T09:30:15
#
#-------------------------------------------------

CONFIG += console

TARGET = HelloCuda

# Define output directories
DESTDIR = ../bin
CUDA_OBJECTS_DIR = OBJECTS_DIR/../cuda

# This makes the .cu files appear in your project
OTHER_FILES += \
    vectorAdd.cu
CUDA_SOURCES += \
    vectorAdd.cu

#-------------------------------------------------

# CUDA settings
CUDA_DIR = "D:/CUDA"                # Path to cuda toolkit install
SYSTEM_NAME = Win32                 # Depending on your system either 'Win32', 'x64', or 'Win64'
SYSTEM_TYPE = 32                    # '32' or '64', depending on your system
CUDA_ARCH = sm_30                   # Type of CUDA architecture
NVCC_OPTIONS = --use_fast_math

# include paths
INCLUDEPATH += $$CUDA_DIR/include \
               $$CUDA_DIR/common/inc \
               $$CUDA_DIR/../shared/inc

# library directories
QMAKE_LIBDIR += $$CUDA_DIR/lib/$$SYSTEM_NAME \
                $$CUDA_DIR/common/lib/$$SYSTEM_NAME \
                $$CUDA_DIR/../shared/lib/$$SYSTEM_NAME

# The following makes sure all path names (which often include spaces) are put between quotation marks
CUDA_INC = $$join(INCLUDEPATH,'" -I"','-I"','"')

# Add the necessary libraries
CUDA_LIB_NAMES = cudart_static kernel32 user32 gdi32 winspool comdlg32 \
                 advapi32 shell32 ole32 oleaut32 uuid odbc32 odbccp32 \
                 #freeglut glew32

for(lib, CUDA_LIB_NAMES) {
    CUDA_LIBS += -l$$lib
}
LIBS += $$CUDA_LIBS

# Configuration of the Cuda compiler
CONFIG(debug, debug|release) {
    # Debug mode
    cuda_d.input = CUDA_SOURCES
    cuda_d.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.obj
    cuda_d.commands = $$CUDA_DIR/bin/nvcc.exe -D_DEBUG $$NVCC_OPTIONS $$CUDA_INC $$LIBS \
                      --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH \
                      --compile -Xcompiler "/wd4819" -g \
                      -DWIN32 -D_MBCS -Xcompiler "/EHsc,/W3,/nologo,/Od,/Zi,/RTC1,/MTd" \
                      -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
    cuda_d.dependency_type = TYPE_C
    QMAKE_EXTRA_COMPILERS += cuda_d
}
else {
    # Release mode
    cuda.input = CUDA_SOURCES
    cuda.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.obj
    cuda.commands = $$CUDA_DIR/bin/nvcc.exe $$NVCC_OPTIONS $$CUDA_INC $$LIBS \
                    --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH \
                    --compile -Xcompiler "/wd4819" -cudart static \
                    -DWIN32 -Xcompiler "/EHsc,/nologo,/Zi,/MT" \
                    -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
    cuda.dependency_type = TYPE_C
    QMAKE_EXTRA_COMPILERS += cuda
}
