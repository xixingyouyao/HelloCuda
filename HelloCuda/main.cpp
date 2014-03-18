#include <QtCore/QCoreApplication>
#include <QDebug>

#include <cuda.h>
#include <builtin_types.h>
#include <drvapi_error_string.h>

// Forward declare the function in the .cu file
void vectorAddition(const float* a, const float* b, float* c, int n);

void printArray(const float* a, const unsigned int n) {
    QString s = "(";
    unsigned int ii;
    for (ii = 0; ii < n - 1; ++ii)
    {
        s.append(QString::number(a[ii])).append(", ");
    }
    s.append(QString::number(a[ii])).append(")");

    qDebug() << s;
}

int main(int argc, char* argv [])
{
    QCoreApplication app(argc, argv);

    int deviceCount = 0;
    int cudaDevice = 0;
    char cudaDeviceName [100];

    unsigned int N = 10;
    float *a, *b, *c;

    cuInit(0);
    cuDeviceGetCount(&deviceCount);
    cuDeviceGet(&cudaDevice, 0);
    cuDeviceGetName(cudaDeviceName, 100, cudaDevice);
    qDebug() << "Number of devices: " << deviceCount;
    qDebug() << "Device name:" << cudaDeviceName;

    a = new float [N];    b = new float [N];    c = new float [N];
    for (unsigned int ii = 0; ii < N; ++ii) {
        a[ii] = qrand();
        b[ii] = qrand();
    }

    // This is the function call in which the kernel is called
    vectorAddition(a, b, c, N);

    qDebug() << "input a:"; printArray(a, N);
    qDebug() << "input b:"; printArray(b, N);
    qDebug() << "output c:"; printArray(c, N);

    if (a) delete a;
    if (b) delete b;
    if (c) delete c;

    qDebug() << "Finished!";

    return app.exec();
}
