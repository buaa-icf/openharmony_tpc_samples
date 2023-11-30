/**
 * 角色
 */
export enum MUCRoomRole
{
    RoleNone = "0",                      /**< Not present in room. */
    RoleVisitor = "1",                    /**< The user visits a room. */
    RoleParticipant = "2",                /**< The user has voice in a moderatd room. */
    RoleModerator = "3",                  /**< The user is a room moderator. */
    RoleInvalid  = "4"                    /**< Invalid role. */
};
