import Express from "express";
const router = Express.Router();
import publicPage from "../models/public_page_model.js";
import auth from "../middleware/auth_middleware.js";


router.post("/publicpage/create", auth, async (req, res) => {
  try {
    const { title, data, icon, creator } = req.body;
    const newPublicPage = new publicPage({
      title,
      data,
      icon,
      creator,
    });
    const public_page = await newPublicPage.save();
    res.status(200).json(public_page);
  } catch (error) {
    res.status(400).json({ msg: "Error creating public page" });
  }
});

router.get("/publicpage/:id/likes", async (req, res) => {
  try {
    const { id } = req.params;
    const public_page = await publicPage.findById(id);
    const likes = public_page.likes;
    res.status(200).json(likes);
  } catch (error) {
    res.status(400).json({ msg: "Error getting page likes" });
  }
});


router.put("/publicpage/:id/likes", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const public_page = await publicPage.findById(id);
    public_page.likes = public_page.likes + 1;
    const updated_public_page = await public_page.save();
    res.status(200).json(updated_public_page);
  } catch (error) {
    res.status(400).json({ msg: "Error getting public books" });
  }
});



router.get("/publicpage", async (req, res) => {
  try {
    var { next } = req.headers;
    next = parseInt(next);

    const public_pages = await publicPage
      .find()
      .sort({ _id: -1 })
      .limit(30 + next);
    res.status(200).json(public_pages);
  } catch (error) {
    console.log(error);
    res.status(400).json({ msg: "Error getting public pages" });
  }
});

export default router;
