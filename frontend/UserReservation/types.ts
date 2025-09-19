// 공용 타입
export type PaymentMethod = 'card' | 'account';

export type Facility = {
  id: string;
  name: string;
  room?: string;
  hourlyPrice: number;
  imageUrl?: string;
  isPaid: boolean;
  minPeople?: number;
  phone?: string;
};

export type Timeslot = {
  date: string;   // YYYY-MM-DD
  start: string;  // HH:mm
  end: string;    // HH:mm
};

export type ReservationDraft = {
  facilityId: string;
  representative: string;
  phone: string;
  date: string;
  start: string;
  hours: number;
  headcount: number;
  totalPrice: number;
};

export type ReservationResult = { reservationId: string };

export type CardInfo = { brand: string; last4: string; holder: string };

export type BankAccount = { id: string; bank: string; masked: string };

export type PaymentRequest = {
  reservationId: string;
  method: PaymentMethod;
  cardInput?: { pan: string; exp: string; cvc: string; holder: string };
  cardSavedId?: string;
  accountId?: string;
  installment?: number;
};

export type PaymentResult = { approved: boolean; approvalNo?: string };
