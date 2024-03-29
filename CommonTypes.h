// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved

#ifndef _COMMONTYPES_H_
#define _COMMONTYPES_H_

#pragma comment(lib, "d3d11.lib")
#pragma comment(lib, "dxgi.lib")
#pragma comment(lib, "d3dcompiler.lib")
#pragma comment(lib, "DirectXCommonClasses.lib")

#include <d3dcompiler.h>
#include <windows.h>
#include <d3d11.h>
#include <dxgi1_2.h>
#include <sal.h>
#include <new>
#include <warning.h>
#include <DirectXMath.h>
#include <iostream>
#include <unordered_map>
#include "InputClass.h"
#include "Time.h"

#include "DummyPP.h"
#include "VertexShader.h"
#include <string>

#define NUMVERTICES 6
#define BPP         4

#define OCCLUSION_STATUS_MSG WM_USER

extern HRESULT SystemTransitionsExpectedErrors[];
extern HRESULT CreateDuplicationExpectedErrors[];
extern HRESULT FrameInfoExpectedErrors[];
extern HRESULT AcquireFrameExpectedError[];
extern HRESULT EnumOutputsExpectedErrors[];

const std::unordered_map<std::string, std::wstring> c_pixelShaders
{
    {"Blur",L"GaussianBlurPP.hlsl"},
    {"Desaturation", L"DesaturationPP.hlsl" },
    {"Dummy", L"DummyPP.hlsl"},
    {"EdgesDetection", L"SobelPP.hlsl"},
    {"SimplifyColors", L"SimplifyColorsPP.hlsl"},
    {"AddingOutline", L"AddingOutlinePP.hlsl"},
    {"OutlineTweaking", L"SobelTweakingPP.hlsl"},
    {"Kuwahara", L"KuwaharaPP.hlsl"},
    {"FishEye", L"FishEye.hlsl"},
    {"Transform", L"TransformPP.hlsl"}
};

typedef _Return_type_success_(return == DUPL_RETURN_SUCCESS) enum
{
    DUPL_RETURN_SUCCESS             = 0,
    DUPL_RETURN_ERROR_EXPECTED      = 1,
    DUPL_RETURN_ERROR_UNEXPECTED    = 2
}DUPL_RETURN;

_Post_satisfies_(return != DUPL_RETURN_SUCCESS)
DUPL_RETURN ProcessFailure(_In_opt_ ID3D11Device* Device, _In_ LPCWSTR Str, _In_ LPCWSTR Title, HRESULT hr, _In_opt_z_ HRESULT* ExpectedErrors = nullptr);

void DisplayMsg(_In_ LPCWSTR Str, _In_ LPCWSTR Title, HRESULT hr);

//
// Holds info about the pointer/cursor
//
typedef struct _PTR_INFO
{
    _Field_size_bytes_(BufferSize) BYTE* PtrShapeBuffer;
    DXGI_OUTDUPL_POINTER_SHAPE_INFO ShapeInfo;
    POINT Position;
    bool Visible;
    UINT BufferSize;
    UINT WhoUpdatedPositionLast;
    LARGE_INTEGER LastTimeStamp;
} PTR_INFO;

//
// Structure that holds D3D resources not directly tied to any one thread
//
typedef struct _DX_RESOURCES
{
    ID3D11Device* Device;
    ID3D11DeviceContext* Context;
    ID3D11VertexShader* VertexShader;
    ID3D11PixelShader* PixelShader;
    ID3D11InputLayout* InputLayout;
    ID3D11SamplerState* SamplerLinear;
} DX_RESOURCES;

//
// Structure to pass to a new thread
//
typedef struct _THREAD_DATA
{
    // Used to indicate abnormal error condition
    HANDLE UnexpectedErrorEvent;

    // Used to indicate a transition event occurred e.g. PnpStop, PnpStart, mode change, TDR, desktop switch and the application needs to recreate the duplication interface
    HANDLE ExpectedErrorEvent;

    // Used by WinProc to signal to threads to exit
    HANDLE TerminateThreadsEvent;

    HANDLE TexSharedHandle;
    UINT Output;
    INT OffsetX;
    INT OffsetY;
    PTR_INFO* PtrInfo;
    DX_RESOURCES DxRes;
} THREAD_DATA;

//
// FRAME_DATA holds information about an acquired frame
//
typedef struct _FRAME_DATA
{
    ID3D11Texture2D* Frame;
    DXGI_OUTDUPL_FRAME_INFO FrameInfo;
    _Field_size_bytes_((MoveCount * sizeof(DXGI_OUTDUPL_MOVE_RECT)) + (DirtyCount * sizeof(RECT))) BYTE* MetaData;
    UINT DirtyCount;
    UINT MoveCount;
} FRAME_DATA;

//
// A vertex with a position and texture coordinate
//
typedef struct _VERTEX
{
    DirectX::XMFLOAT3 Pos;
    DirectX::XMFLOAT2 TexCoord;
} VERTEX;

struct FishEyeProperties
{
    float factor;
    DirectX::XMFLOAT3 padding;
};

struct TransformProperties
{
    float zoom;
    DirectX::XMFLOAT2 offset;
    float padding;
};

#endif
