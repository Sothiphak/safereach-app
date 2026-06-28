import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

import { UsersModule } from '../users/users.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtStrategy } from './jwt.strategy';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (configService) => {
        const jwtSecret = configService.get('JWT_SECRET');
        if (!jwtSecret && configService.get('NODE_ENV') === 'production') {
          throw new Error('JWT_SECRET is required in production.');
        }

        return {
          secret: jwtSecret || 'safereach-dev-secret',
          signOptions: {
            expiresIn: configService.get('JWT_EXPIRES_IN', '7d'),
          },
        };
      },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
})
export class AuthModule {}
