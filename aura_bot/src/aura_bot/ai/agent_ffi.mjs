import { GoogleGenAI } from "@google/genai";

export function googleGenAI(apiKey) {
  return new GoogleGenAI({ vertexai: false, apiKey: apiKey });
}
