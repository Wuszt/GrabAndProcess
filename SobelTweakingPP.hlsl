// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

static const float2 offset = float2(1 / 1920.0f, 1 / 1080.0f);
static const float PI = 3.14159265f;

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float2 ExtractXandY(float4 input)
{
    return input.xy * 2.0f - 1.0f;
}

float3 GetDataForPixelWithOffset(float2 mainCoords, float2 off)
{
    float4 samp = tx.Sample(samLinear, mainCoords + off * offset);
    return float3(ExtractXandY(samp), samp.z);
}

bool Discard(float3 data, float angle, float mainCoords, float2 a0, float2 a1, float2 topOffset0, float2 topOffset1, float2 botOffset0, float2 botOffset1)
{
    if ((angle >= a0.x && a0.y > angle) || (angle >= a1.x && a1.y > angle))
    {
        float top0 = GetDataForPixelWithOffset(mainCoords, topOffset0).z;
        float top1 = GetDataForPixelWithOffset(mainCoords, topOffset1).z;


        float bot0 = GetDataForPixelWithOffset(mainCoords, botOffset0);
        float bot1 = GetDataForPixelWithOffset(mainCoords, botOffset1);

        float x_est = abs(data.y / data.z);

        return !(data.z >= ((bot1 - bot0)*x_est + bot0)
            && data.z >= ((top1 - top0)*x_est + top0));
    }

    return false;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
   float3 data = GetDataForPixelWithOffset(input.Tex, float2(0,0));

   float mg = data.z;

   //float angle = atan2(data.y, data.x) * 180 / PI;

   //if (Discard(data, angle, input.Tex, float2(0, 45), float2(-180, -135), float2(1, 0), float2(1, 1), float2(-1, 0), float2(-1, -1))
   //    || (Discard(data, angle, input.Tex, float2(45, 90), float2(-135, -90), float2(0, 1), float2(1, 1), float2(0, -1), float2(-1, -1)))
   //    || (Discard(data, angle, input.Tex, float2(90, 135), float2(-90, -45), float2(0, 1), float2(-1, 1), float2(0, -1), float2(1, -1)))
   //    || (Discard(data, angle, input.Tex, float2(135, 180), float2(-45, 0), float2(-1, 0), float2(-1, 1), float2(1, 0), float2(1, -1))))
   //    mg = 0;

   return float4(mg, mg, mg, 1.0f);
}