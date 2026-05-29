import { ValidationPipe } from '@nestjs/common';

export const buildValidationPipe = (expectedType) =>
  new ValidationPipe({
    transform: true,
    whitelist: true,
    forbidNonWhitelisted: true,
    expectedType,
  });
