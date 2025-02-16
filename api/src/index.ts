import { Hono } from "hono";

const app = new Hono<{ Bindings: CloudflareBindings }>();

app.route("/", (await import("./handlers/root")).default);
app.route("/auth", (await import("./handlers/auth")).default);

export default app;
