import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AppController } from './app.controller';
import { AuthModule } from './modules/auth/auth.module';
import { BranchesModule } from './modules/branches/branches.module';
import { ContactsModule } from './modules/contacts/contacts.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { ServicesModule } from './modules/services/services.module';
import { TipsModule } from './modules/tips/tips.module';
import { UsersModule } from './modules/users/users.module';
import { SeedModule } from './seed/seed.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService) => {
        const dbType = configService.get('DB_TYPE', 'postgres');
        const synchronize = configService.get('DB_SYNC', 'true') === 'true';
        const logging = configService.get('DB_LOGGING', 'false') === 'true';

        if (dbType === 'sqlite') {
          return {
            type: 'sqlite',
            database: configService.get('DB_DATABASE', ':memory:'),
            autoLoadEntities: true,
            synchronize,
            logging,
          };
        }

        const sslEnabled = configService.get('DB_SSL', 'false') === 'true';

        return {
          type: 'postgres',
          host: configService.get('DB_HOST', 'localhost'),
          port: Number(configService.get('DB_PORT', 5432)),
          username: configService.get('DB_USERNAME'),
          password: configService.get('DB_PASSWORD'),
          database: configService.get('DB_DATABASE'),
          autoLoadEntities: true,
          synchronize,
          logging,
          ssl: sslEnabled ? { rejectUnauthorized: false } : false,
        };
      },
    }),
    UsersModule,
    AuthModule,
    ServicesModule,
    BranchesModule,
    ReviewsModule,
    TipsModule,
    ContactsModule,
    SeedModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
