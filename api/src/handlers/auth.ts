import { Hono } from "hono";

const route = new Hono<{ Bindings: CloudflareBindings }>();

route.get("/", (c) => {
	return c.text("Hello Hono!");
});

export default route;
