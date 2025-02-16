import { Hono } from "hono";

import rootRoutes from "./handlers/root";

const app = new Hono<{ Bindings: CloudflareBindings }>();

app.route("/", rootRoutes);

export default app;
