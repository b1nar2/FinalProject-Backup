import React from 'react';

type ButtonSize = 'sm' | 'md' | 'lg';
type ButtonVariant = 'primary' | 'neutral' | 'danger' | 'outline';

type ButtonProps = {
  onClick: () => void;
  label: string;
  size?: ButtonSize;
  variant?: ButtonVariant;
  className?: string;          // 선택: 스타일 커스터마이즈
};

export function Button({ onClick, label, size = 'md', variant = 'neutral', className }: ButtonProps) {
  const cls = ['btn', `btn-${variant}`, `btn-${size}`, className].filter(Boolean).join(' ');
  return <button onClick={onClick} className={cls}>{label}</button>;
}
