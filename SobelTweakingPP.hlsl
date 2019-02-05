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

float2 ExtractXandY(float4 input)
{
    return input.xy * 2.0f - 1.0f;
}

float2 GetDataForPixelWithOffset(float2 mainCoords, float2 off)
{
    return ExtractXandY(tx.Sample(samLinear, mainCoords + off * offset));
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
   float2 data = GetDataForPixelWithOffset(input.Tex, float2(0,0));

   float mg = sqrt(data.x * data.x + data.y * data.y);

   float angle = atan2(data.y, data.x);

   return float4(mg, mg, mg, 1.0f);
}