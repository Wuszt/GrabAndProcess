// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float2 GetCenteredUVs(float2 uv)
{
    uv -= 0.5f;
    uv.y *= -1.0f;

    uv.x *= 16.0f / 9.0f;

    return uv;
}

float2 GetRevertedCenteredUVs(float2 uv)
{
    uv.x *= 9.0f / 16.0f;
    uv.y *= -1.0f;
    uv += 0.5f;

    return uv;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    float2 uv = GetCenteredUVs(input.Tex);
    float factor = 2.25f;
    float r = length(uv) * factor;

    float theta = atan(r) / r;

    uv *= theta;

    uv = GetRevertedCenteredUVs(uv);

    return tx.Sample(samLinear, uv);
}