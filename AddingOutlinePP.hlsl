Texture2D tx : register(t0);
Texture2D outline : register(t1);
SamplerState samLinear : register(s0);

static float2 offset = float2(1 / 1920.0f, 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float4 PS(PS_INPUT input) : SV_Target
{
    return tx.Sample(samLinear, input.Tex) * (1.0f - outline.Sample(samLinear, input.Tex).r);
}