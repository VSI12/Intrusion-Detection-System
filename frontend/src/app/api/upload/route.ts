export async function POST(req: Request) {
    const formData = await req.formData();
    
    const response = await fetch(`http://${process.env.INTERNAL_FLASK_API}/upload`, {
      method: "POST",
      body: formData,
    });
  
    const result = await response.json();
    return new Response(JSON.stringify(result));
  }
  