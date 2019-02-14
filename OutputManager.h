// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved

#ifndef _OUTPUTMANAGER_H_
#define _OUTPUTMANAGER_H_

#include <stdio.h>

#include "CommonTypes.h"
#include "warning.h"
#include "DebugLogger.h"
#include <sstream>
#include <iomanip>

struct MultipassResource
{
    ID3D11Texture2D* Texture;
    ID3D11RenderTargetView* Target;
};

//
// Handles the task of drawing into a window.
// Has the functionality to draw the mouse given a mouse shape buffer and position
//
class OUTPUTMANAGER
{
    public:
        OUTPUTMANAGER();
        ~OUTPUTMANAGER();
        DUPL_RETURN InitOutput(HWND Window, INT SingleOutput, _Out_ UINT* OutCount, _Out_ RECT* DeskBounds);
        DUPL_RETURN UpdateApplicationWindow(_In_ PTR_INFO* PointerInfo, _Inout_ bool* Occluded);
        void CleanRefs();
        HANDLE GetSharedHandle();
        DUPL_RETURN DrawPass(std::string ppName, std::vector<ID3D11Texture2D*> textures, ID3D11RenderTargetView * targetView);
        void ProcessEdgeDetection(ID3D11Texture2D * source, ID3D11RenderTargetView * target);
        void ProcessFishEye(ID3D11Texture2D * source, ID3D11RenderTargetView * target);
        void ProcessCellShading(ID3D11Texture2D * source, ID3D11RenderTargetView * target);
        void ProcessTransformation(ID3D11Texture2D * source, ID3D11RenderTargetView * target);
        int HandleModeChange();
        void WindowResize();

    private:
    // Methods
        DUPL_RETURN ProcessMonoMask(bool IsMono, _Inout_ PTR_INFO* PtrInfo, _Out_ INT* PtrWidth, _Out_ INT* PtrHeight, _Out_ INT* PtrLeft, _Out_ INT* PtrTop, _Outptr_result_bytebuffer_(*PtrHeight * *PtrWidth * BPP) BYTE** InitBuffer, _Out_ D3D11_BOX* Box);
        DUPL_RETURN MakeRTV();
        void SetViewPort(UINT Width, UINT Height);
        DUPL_RETURN InitInputLayout();
        DUPL_RETURN InitVertexShaders();
        DUPL_RETURN InitPixelShaders();
        DUPL_RETURN InitGeometry();
        DUPL_RETURN CreateSharedSurf(INT SingleOutput, _Out_ UINT* OutCount, _Out_ RECT* DeskBounds);
        DUPL_RETURN DrawFrame();
        DUPL_RETURN DrawMouse(_In_ PTR_INFO* PtrInfo);
        DUPL_RETURN ResizeSwapChain();

        DUPL_RETURN InitializeMultipassResources();

        MultipassResource* CreateMultipassResource();

        MultipassResource* AcquireMultipassResource();

        void ReleaseMultipassResource(MultipassResource* resource);

        DUPL_RETURN InitializeMultipassResource(RECT * DeskBounds, ID3D11Texture2D ** tex, ID3D11RenderTargetView ** targetView);

        void CleanPixelShaders();

        void CleanMultipassTexturesAndTargets();

        void CleanMultipassResources();

    // Vars
        IDXGISwapChain1* m_SwapChain;
        ID3D11Device* m_Device;
        IDXGIFactory2* m_Factory;
        ID3D11DeviceContext* m_DeviceContext;
        ID3D11RenderTargetView* m_RTV;
        ID3D11SamplerState* m_SamplerLinear;
        ID3D11BlendState* m_BlendState;
        ID3D11VertexShader* m_VertexShader;
        std::unordered_map<std::string, ID3D11PixelShader*> m_PixelShaders;
        ID3D11InputLayout* m_InputLayout;
        ID3D11Texture2D* m_SharedSurf;
        IDXGIKeyedMutex* m_KeyMutex;
        HWND m_WindowHandle;
        bool m_NeedsResize;
        DWORD m_OcclusionCookie;

        std::vector<MultipassResource*> m_resourcesPool;
        std::vector<MultipassResource*> m_usedResources;
};

#endif
