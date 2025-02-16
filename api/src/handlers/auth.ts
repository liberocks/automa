import { Hono } from "hono";

import bcrypt from "bcryptjs";

const route = new Hono<{ Bindings: CloudflareBindings }>();

route.get("/:password", async (c) => {
    const CORRECT_PASSWORD = "password123";
    const CORRECT_PASSWORD_SALT = await bcrypt.genSalt(10);
    const CORRECT_PASSWORD_HASH = await bcrypt.hash(CORRECT_PASSWORD, CORRECT_PASSWORD_SALT);

    const password = c.req.param("password");

    return c.json({
        isCorrect: await bcrypt.compare(password, CORRECT_PASSWORD_HASH),
    });
});

export default route;
