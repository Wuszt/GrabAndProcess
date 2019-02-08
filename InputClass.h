#pragma once

#ifndef _INPUTCLASS_H_
#define _INPUTCLASS_H_

#include <DirectXMath.h>

#pragma comment (lib, "dinput8.lib")
#pragma comment (lib, "dxguid.lib")

#include <dinput.h>

using namespace DirectX;

class InputClass
{
public:
    bool Initialize(HINSTANCE, HWND);

    void UpdateInput();

    bool IsKeyDown(unsigned int);
    XMFLOAT3 GetMouseDeltaPosition();
    bool IsMouseButtonDown(unsigned int input);
    XMFLOAT2 GetMouseCurrentPosition();

    static InputClass* GetSingleton();

private:
    InputClass();
    InputClass(const InputClass&);
    ~InputClass();

    BYTE m_keyboardState[256];

    HWND m_hwnd;

    IDirectInputDevice8* m_DIKeyboard;
    IDirectInputDevice8* m_DIMouse;

    DIMOUSESTATE m_lastMouseState;
    LPDIRECTINPUT8 m_directInput;

    static InputClass s_singleton;
};

#endif