import tagString from "./tagString";
import parse from "./parse";

export default function tag(...args) {
  return parse(tagString(...args));
}
