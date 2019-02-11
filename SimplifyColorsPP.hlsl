// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

static float2 offset = float2(1 / 1920.0f , 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float4 MySimplify(float3 clr)
{
    float l = length(clr);

    clr /= l;
    if (l < 0.95f)
    {
        l = (int)(10.0f * l);
        //l -= l % 2;
        l /= 10.0f;
    }
    clr *= l;

    return float4(clr, 1.0f);
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    float3 clr = tx.Sample(samLinear, input.Tex).rgb;
    return MySimplify(clr);
}