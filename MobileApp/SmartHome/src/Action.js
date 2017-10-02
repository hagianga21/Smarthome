export const InsertURL = 'InsertURL';

export function insertServerURL(url){
    return {type: InsertURL, url}
}