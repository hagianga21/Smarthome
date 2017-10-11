export const InsertURL = 'InsertURL';
export const stateChanged = 'StateChanged';
export const timeOnChanged = 'TimeOnChanged';
export const timeOffChanged = 'TimeOffChanged';

export function insertServerURL(url){
    return {type: InsertURL, url}
}

export function changeState(name,state){
    return {type: stateChanged, name, state}
}

export function changeTimeOn(name,time){
    return {type: timeOnChanged, name, time}
}

export function changeTimeOff(name,time){
    return {type: timeOffChanged, name, time}
}