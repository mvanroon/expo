export type NetworkState = {
  type?: NetworkStateType;
  isConnected?: boolean;
  isInternetReachable?: boolean;
};

export enum NetworkStateType {
  NONE = 'NONE',
  UNKNOWN = 'UNKNOWN',
  CELLULAR = 'CELLULAR',
  WIFI = 'WIFI',
  BLUETOOTH = 'BLUETOOTH',
  ETHERNET = 'ETHERNET',
  WIMAX = 'WIMAX',
  VPN = 'VPN',
  OTHER = 'OTHER',
}
