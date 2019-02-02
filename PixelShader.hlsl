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

float GetGreyscaledAndBlurredPixel(float2 coords)
{
    return tx.Sample(samLinear, coords);

    float clr = 0.0f;

    float2 offset = float2(1 / 1440.0f, 1 / 900.0f);

    int size = 5;
    int halfSize = size * 0.5f;

    int multipliers[][5] =
    {
        { 1, 1, 2, 1, 1 },
        { 1, 2, 4, 2, 1 },
        { 2, 4, 8, 4, 2 },
        { 1, 2, 4, 2, 1 },
        { 1, 1, 2, 1, 1 },
    };

    for (int x = -halfSize; x <= halfSize; ++x)
    {
        for (int y = -halfSize; y <= halfSize; ++y)
        {
            float4 tmp = tx.Sample(samLinear, coords + float2(x, y) * offset);

            clr += multipliers[halfSize + x][halfSize + y] * (tmp.r * 0.3f + tmp.g * 0.59f + tmp.b * 0.11f);
        }
    }

    return clr / 52.0f;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    float2 offset = float2(1 / 1440.0f, 1 / 900.0f);
    float leftUp = GetGreyscaledAndBlurredPixel(input.Tex + float2(-1, 1) * offset);
    float leftMid = GetGreyscaledAndBlurredPixel(input.Tex + float2(-1, 0) * offset);
    float leftDown = GetGreyscaledAndBlurredPixel(input.Tex + float2(-1, -1) * offset);

    float midUp = GetGreyscaledAndBlurredPixel(input.Tex + float2(0, 1) * offset);
    float midMid = GetGreyscaledAndBlurredPixel(input.Tex + float2(0, 0) * offset);
    float midDown = GetGreyscaledAndBlurredPixel(input.Tex + float2(0, -1) * offset);

    float rightUp = GetGreyscaledAndBlurredPixel(input.Tex + float2(1, 1) * offset);
    float rightMid = GetGreyscaledAndBlurredPixel(input.Tex + float2(1, 0) * offset);
    float rightDown = GetGreyscaledAndBlurredPixel(input.Tex + float2(1, -1) * offset);

    float x = leftUp + 2 * midUp + rightUp - leftDown - 2 * midDown - rightDown;
    float y = leftUp + 2 * leftMid + leftDown - rightUp - 2 * rightMid - rightDown;
    x = clamp(x, 0.0f, 1.0f);
    y = clamp(y, 0.0f, 1.0f);

    float mg = sqrt(x * x + y * y);
    return mg;//float4(mg, mg, mg, 1.0f);
}