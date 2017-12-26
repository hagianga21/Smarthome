export const InsertURL = 'InsertURL';
export const stateChanged = 'StateChanged';
export const timeOnChanged = 'TimeOnChanged';
export const timeOffChanged = 'TimeOffChanged';
export const tempChanged = 'TempChanged';
export const humidChanged = 'HumidChanged';
export const gasChanged = 'GasChanged';

export function insertServerURL(url){
    return {type: InsertURL, url}
}

export function changeState(name,state){
    return {type: stateChanged, name, state}
}

export function changeTemp(temp){
    return {type: tempChanged, temp}
}

export function changeHumid(humid){
    return {type: humidChanged, humid}
}

export function changeGas(gas){
    return {type: gasChanged, gas}
}

export function changeTimeOn(name,time){
    return {type: timeOnChanged, name, time}
}

export function changeTimeOff(name,time){
    return {type: timeOffChanged, name, time}
}