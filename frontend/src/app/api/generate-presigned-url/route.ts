import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3 = new S3Client({
  region: process.env.AWS_REGION!,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID!,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY!,
  },
});

export async function POST(req: Request) {
  try {
    const { file_name, file_type } = await req.json();

    if (!file_name || !file_type) {
      return new Response(JSON.stringify({ error: "Missing file_name or file_type" }), {
        status: 400,
      });
    }

    console.log("Generating presigned URL for:", file_name, file_type);

    const command = new PutObjectCommand({
      Bucket: process.env.S3_BUCKET_NAME!,
      Key: `uploads/${file_name}`,
      ContentType: file_type,
    });

    const url = await getSignedUrl(s3, command, { expiresIn: 60 });

    console.log("Generated URL:", url);

    return new Response(JSON.stringify({ url }), { status: 200 });
  } catch (error) {
    console.error("Presigned URL Error:", error);
    return new Response(JSON.stringify({ error: (error as Error).message }), { status: 500 });
  }
}
