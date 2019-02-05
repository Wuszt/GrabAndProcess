// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

static float2 offset = float2(1 / 1920.0f, 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    float leftUp = tx.Sample(samLinear, input.Tex + float2(-1, 1) * offset).r;
    float leftMid = tx.Sample(samLinear, input.Tex + float2(-1, 0) * offset).r;
    float leftDown = tx.Sample(samLinear, input.Tex + float2(-1, -1) * offset).r;

    float midUp = tx.Sample(samLinear, input.Tex + float2(0, 1) * offset).r;
    float midMid = tx.Sample(samLinear, input.Tex + float2(0, 0) * offset).r;
    float midDown = tx.Sample(samLinear, input.Tex + float2(0, -1) * offset).r;

    float rightUp = tx.Sample(samLinear, input.Tex + float2(1, 1) * offset).r;
    float rightMid = tx.Sample(samLinear, input.Tex + float2(1, 0) * offset).r;
    float rightDown = tx.Sample(samLinear, input.Tex + float2(1, -1) * offset).r;

    float x = leftUp + 2 * midUp + rightUp - leftDown - 2 * midDown - rightDown;
    float y = leftUp + 2 * leftMid + leftDown - rightUp - 2 * rightMid - rightDown;

    float magnitude = sqrt(x*x + y*y);

    x = (x + 1.0f) / 2.0f;
    y = (y + 1.0f) / 2.0f;

    return float4(x, y, magnitude, 1.0f);
}