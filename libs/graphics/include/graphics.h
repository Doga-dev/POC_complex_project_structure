#ifndef GRAPHICS_H
#define GRAPHICS_H

#include <QObject>

#include "graphics_global.h"

class GRAPHICS_EXPORT Graphics : public QObject {
    Q_OBJECT
public:
    explicit   Graphics   (QObject * parent = nullptr);
    virtual    ~Graphics  ();
};

#endif // GRAPHICS_H

