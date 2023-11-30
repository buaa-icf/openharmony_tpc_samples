/**
 * 从属关系（岗位）
 */
export enum MUCRoomAffiliation {
    AffiliationNone = "0", /**< No affiliation with the room. */
    AffiliationOutcast = "1", /**< The user has been banned from the room. */
    AffiliationMember = "2", /**< The user is a member of the room. */
    AffiliationOwner = "3", /**< The user is a room owner. */
    AffiliationAdmin = "4", /**< The user is a room admin. */
    AffiliationInvalid = "5" /**< Invalid affiliation. */
}
;
