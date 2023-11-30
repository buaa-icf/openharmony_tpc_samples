export enum PresenceRoomType {
    Available = "0", /**< The entity is online. */
    Chat = "1", /**< The entity is 'available for chat'. */
    Away = "2", /**< The entity is away. */
    DND = "3", /**< The entity is DND (Do Not Disturb). */
    XA = "4", /**< The entity is XA (eXtended Away). */
    Unavailable = "5", /**< The entity is offline. */
    Probe = "6", /**< This is a presence probe. */
    Error = "7", /**< This is a presence error. */
    Invalid = "8" /**< The stanza is invalid. */
}